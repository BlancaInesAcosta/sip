# encoding: UTF-8
module Sip
  module Admin
    class TclasesController < BasicasController
      before_action :set_tclase, only: [:show, :edit, :update, :destroy]
      load_and_authorize_resource class: Sip::Tclase
  
      def clase 
        "Sip::Tclase"
      end
  
      def set_tclase
        @basica = Tclase.find(params[:id])
      end
  
      def genclase
        return 'M';
      end

      def tclase_params
        params.require(:tclase).permit(*atributos_form)
      end
  
    end
  end
end
