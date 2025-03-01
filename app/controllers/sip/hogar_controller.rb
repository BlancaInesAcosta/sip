# encoding: UTF-8
module Sip
  class HogarController < ApplicationController

    def tablasbasicas
      @ntablas = {}
      @ntablasor = Sip::ModeloHelper.lista_tablas_basicas(
        current_ability, @ntablas
      )
      render layout: 'application'
    end

    def verificarutas
      em = ""
      if !File.directory?(Sip.ruta_anexos) 
      	em += "No existe ruta de anexos '#{Sip.ruta_anexos}'. "
      end
      if !File.directory?(Sip.ruta_volcados) 
      	em += "No existe ruta de volcados '#{Sip.ruta_volcados}'. "
      end
      if em != ''
        flash[:error] = em
      end
    end

    def index
      if current_usuario
        authorize! :read, Sip::Pais
      end
      verificarutas
      render layout: 'application'
    end

    def acercade
      verificarutas
      render layout: 'application'
    end

    def ayuda_controldeacceso
      verificarutas
      render layout: 'application'
    end


  end
end
