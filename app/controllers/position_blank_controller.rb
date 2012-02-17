class PositionBlankController < ApplicationController
    skip_before_filter :verify_authenticity_token
    
    #def read
    #search = " pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null) "
    #str_join = ""
    #str_join += " LEFT JOIN cposition ON cposition.poscode = pisj18.poscode "
    #str_join += " LEFT JOIN cgrouplevel ON cgrouplevel.ccode = pisj18.c "
    #rs = PositionBlank.joins(str_join)
    #rs = rs.find(:all, :conditions => search)
    #return_data = {}
    #return_data[:Records]   = rs.collect{|u|

    #  {
    #    :posid => u.posid,
    #    :posname => "#{Cposition.find(u.poscode).posname} #{Cgrouplevel.find(u.c).clname}"
    #  }
    #}
    #render :text => return_data.to_json,:layout => false
    #end
    
    
    
    def art
        #begin
        
        #    Cjob.transaction do
        #       rs1 = Cjob.new
        #       rs1.jobcode = 888
        #       rs1.save!
        #       rs2 = Cposition.new
        #       rs2.poscode = 99999
        #       rs2.save!
        #    end
        #    render :text => "{success: true}"
        #rescue
        #    return_data = {}
        #    return_data[:success] = false
        #    return_data[:msg] = "กรุณาลองตรวจสอบข้อมูลและลองใหม่อีกครั้ง"
        #    render :text => return_data.to_json, :layout => false
        #end
         
        #begin
        #    Cjob.transaction do
        #       Cjob.delete(888)
        #       Cposition.delete(99999)
        #    end
        #    render :text => "{success: true}"
        #rescue
        #    return_data = {}
        #    return_data[:success] = false
        #    return_data[:msg] = "กรุณาลองตรวจสอบข้อมูลและลองใหม่อีกครั้ง"
        #    render :text => return_data.to_json, :layout => false
        #end
        
        begin
            Cjob.transaction do
               rs = Cjob.find(888)
               rs.jobname = "งานทดสอบ222"
               rs.save!
               rs2 = Cposition.find(99999)
               rs2.posname = 'ตำแหน่งทดสอบ222'
               rs2.save!
            end
            render :text => "{success: true}"
        rescue
            return_data = {}
            return_data[:success] = false
            return_data[:msg] = "กรุณาลองตรวจสอบข้อมูลและลองใหม่อีกครั้ง"
            render :text => return_data.to_json, :layout => false
        end        
        
        #if QueryPis.insert_by_arg(params[:t],"cjob")
        #    return_data = {}
        #    return_data[:success] = true            
        #    render :text => return_data.to_json, :layout => false
        #  else
        #    return_data = {}
        #    return_data[:success] = false
        #    return_data[:msg] = "กรุณาลองตรวจสอบข้อมูลและลองใหม่อีกครั้ง"
        #    render :text => return_data.to_json, :layout => false
        #  end
    end
end
