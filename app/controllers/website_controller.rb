class WebsiteController < ApplicationController
  before_action :set_estados
  skip_before_action :authenticate_user!

  def index
    @adotante = Adotante.new
    @errors = false
  end

  def create
    @adotante = Adotante.new(adotante_params)
    persistence_ok = @adotante.save
    @errors = !persistence_ok
    adocao = adotar_povo_filho(@adotante) if persistence_ok
    enviar_adocao(adocao, @adotante) unless adocao.blank?
    tratar_retorno persistence_ok
  end

  private

  def adotar_povo_filho(adotante)
    povo_filho = Pna.proximo_da_fila
    return nil unless povo_filho
    
    adotante.adotar povo_filho
    povo_filho
  end

  def enviar_adocao(adocao, adotante)
    AdocaoMailer.nova_adocao(adocao, adotante).deliver_later
  end

  def tratar_retorno(entity_persistence_ok)
    respond_to do |format|
      if entity_persistence_ok
        format.html { redirect_to website_index_path, notice: 'true' }
        format.json { render :show, status: :created, location: @adotante }
      else
        format.html { render :index }
        format.json { render json: @adotante.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_estados
    @estados = Estado.all
  end

  def adotante_params
    params.require(:adotante).permit(:nome, :estado, :email, :telefone, :pedido_oracao, :marcou_comprometimento)
  end

end
