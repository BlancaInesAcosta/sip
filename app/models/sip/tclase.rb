# encoding: UTF-8
module Sip
  class Tclase < ActiveRecord::Base
    include Basica

    has_many :clase, foreign_key: "id_tclase", validate: true, 
      class_name: 'Sip::Clase'
  end
end
