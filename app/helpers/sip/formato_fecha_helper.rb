#encoding: UTF-8 

module Sip
  module FormatoFechaHelper


    MESES=["", 
           "Enero",
           "Febrero",
           "Marzo",
           "Abril",
           "Mayo",
           "Junio",
           "Julio",
           "Agosto",
           "Septiembre",
           "Octubre",
           "Noviembre",
           "Diciembre"]

    ABMESES=["",
             "Ene",
             "Feb",
             "Mar",
             "Abr",
             "May",
             "Jun",
             "Jul",
             "Ago",
             "Sep",
             "Oct",
             "Nov",
             "Dic"]
    # Este ayudador emplea Rails.application.config.x.formato_fecha 
    # al que llama formato local.  
    #
    # Ese formato local es apropiado para la libreria datepicker de 
    # Javascript que infortunadamente es diferente a POSIX
    # Por el momento soporta bien:
    # dd-M-yyyy, dd/M/yyyy, dd-mm-yyyy, dd/mm/yyyy y yyyy-mm-ddd
    # 
    # El formato estándar es el usado por PostgreSQL yyyy-mm-dd
  
    def fecha_local_colombia_estandar(f, menserror=nil)
        # Date.strptime(f, '%d-%M-%Y') no ha funcionado, 
        # %b debe ser en ingles
        # datepicker produce meses cortos comenzando en mayúsculas.
        # rails-i18n I18n.localize con %b produce mes en minuscula 
      if !f 
        return nil
      end
      if f == ''
        return ''
      end

      nf = nil
      pf = f.split('/')
      if pf.count < 3 
        pf = f.split('-')
      end
      if pf.count < 3
        if menserror
          menserror << "  Formato de fecha en locale de colombia desconocido: #{f}"
        else
          puts "Formato de fecha en locale de colombia desconocido: #{f}"
        end
        return nil;
        nf = Date.strptime(f, '%d-%M-%Y').strftime('%Y-%m-%d')
      else
        return nil if !pf[1]
        m = case pf[1].downcase
            when 'ene' 
              1
            when 'feb' 
              2
            when 'mar' 
              3
            when 'abr' 
              4
            when 'may' 
              5
            when 'jun' 
              6
            when 'jul' 
              7
            when 'ago' 
              8
            when 'sep' 
              9
            when 'oct' 
              10
            when 'nov' 
              11
            else 
              12
            end
        begin
            nf = Date.new(pf[2].to_i, m, pf[0].to_i).strftime('%Y-%m-%d')
        rescue
          if menserror
            menserror << "  Formato de fecha en locale de colombia desconocido: #{f}"
          else
            puts "Formato de fecha en locale de colombia desconocido: #{f}"
          end
        end
      end
      return nf
    end 
    module_function :fecha_local_colombia_estandar

    # Convierte una fecha de formato local a formato estándar
    def fecha_local_estandar f
      if !f 
        return nil
      end
      if f == ''
        return ''
      end
      case Rails.application.config.x.formato_fecha
      when 'dd/M/yyyy', 'dd-M-yyyy'
        nf = fecha_local_colombia_estandar f
      when 'dd-mm-yyyy'
        nf = Date.strptime(f, '%d-%m-%Y').strftime('%Y-%m-%d')
      when 'dd/mm/yyyy'
        nf = Date.strptime(f, '%d/%m/%Y').strftime('%Y-%m-%d')
      else
        nf = Date.strptime(f, '%Y-%m-%d').strftime('%Y-%m-%d')
      end
      return nf
    end
    module_function :fecha_local_estandar


    # Convierte una fecha de formato estándar a formato local
    def fecha_estandar_local f
      if !f || (f.class != String && f.class != Date) || 
        (f.class == String && f == '')
        return nil
      end
      if f.class == String
        fr = Date.strptime(f, '%Y-%m-%d')
      elsif f.class == Date
        fr = f
      end
      case Rails.application.config.x.formato_fecha 
      when 'dd/M/yyyy'
        nf = I18n.localize(fr, :format => '%d/%b/%Y')
      when 'dd-M-yyyy'
        nf = I18n.localize(fr, :format => '%d-%b-%Y')
      when 'dd-mm-yyyy'
        nf = fr.strftime('%d-%m-%Y')
      when 'dd/mm/yyyy'
        nf = fr.strftime('%d/%m/%Y')
      else
        nf = fr.strftime('%Y-%m-%d')
      end
      return nf
    end
    module_function :fecha_estandar_local

    # Adivina locale de fecha y retorna Date
    def reconoce_adivinando_locale(f, menserror = nil)
      if !f || (f.class != String && f.class != Date) || 
        (f.class == String && f == '')
        return nil
      end
      if f.class == Date
        return f
      end
      if f.include?('/')
        #'dd/M/yyyy'
        nf =fecha_local_colombia_estandar(f, menserror)
      else
        nf = f
      end
      begin
        r = Date.strptime(nf, '%Y-%m-%d')
      rescue
        r = nil
        if menserror
          menserror << "  Formato de fecha desconocido: #{f}"
        else
          puts "Formato de fecha desconocido: #{f}"
        end
      end

      return r
    end
    module_function :reconoce_adivinando_locale


    def inicio_semestre(f)
      if f.month <= 6
        Date.new(f.year, 1, 1)
      else
        Date.new(f.year, 7, 1)
      end 
    end
    module_function :inicio_semestre

    def fin_semestre(f)
      if f.month <= 6
        Date.new(f.year, 6, 30)
      else
        Date.new(f.year, 12, 31)
      end 
    end
    module_function :fin_semestre


  end
end
