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
    
    def rc_insert_update
        groupname = params[:groupname]
        username = params[:username]
        begin
            Cposition.transaction do
                rs1 = GroupUsers.new
                rs1.name = groupname
                rs1.save!
                
                rs3 = GroupUsers.find_by_sql("select max(id) as group_user_id from group_users")
                group_user_id = rs3[0].group_user_id

                rs2 = Users.new
                rs2.username = username
                rs2.group_user_id = group_user_id
                rs2.save!

                rs3 = Users.find_by_sql("select max(id) as user_id from users")
                user_id = rs3[0].user_id
                
                rs4 = Users.find(user_id)
                rs4.email = 'saipin@hotmail.com'
                rs4.save!
            end
            render :text => "{success: true}"
        rescue
            return_data = {}
            return_data[:success] = false
            return_data[:msg] = "กรุณาลองตรวจสอบข้อมูลและลองใหม่อีกครั้ง"
            render :text => return_data.to_json, :layout => false
        end
    end
    
    def rc_insert
        begin
            Cposition.transaction do
                rs1 = Cjob.new
                rs1.jobcode = 888
                rs1.jobname = "test_job"
                rs1.save!
                
                rs2 = Cj18status.new
                rs2.j18code = 888
                rs2.j18status = "test_j18"
                rs2.save!
            end
            render :text => "{success: true}"
        rescue
            return_data = {}
            return_data[:success] = false
            return_data[:msg] = "กรุณาลองตรวจสอบข้อมูลและลองใหม่อีกครั้ง"
            render :text => return_data.to_json, :layout => false
        end
    end
    
    def rc_update
        begin
            Cposition.transaction do
               rs1 = Cjob.find(888)
               rs1.jobname = "งานทดสอบ333"
               rs1.save!
               
               rs2 = Cj18status.find(888)
               rs2.j18status = 'ตำแหน่งทดสอบ333'
                rs2.use_status = 1
               rs2.save!
            end
            render :text => "{success: true}"
        rescue
            return_data = {}
            return_data[:success] = false
            return_data[:msg] = "กรุณาลองตรวจสอบข้อมูลและลองใหม่อีกครั้ง"
            render :text => return_data.to_json, :layout => false
        end 
    end
    
    def rc_delete
        begin
            Cposition.transaction do
               Cjob.delete(888)
               
               Cj18status.delete(888)
            end
            render :text => "{success: true}"
        rescue
            return_data = {}
            return_data[:success] = false
            return_data[:msg] = "กรุณาลองตรวจสอบข้อมูลและลองใหม่อีกครั้ง"
            render :text => return_data.to_json, :layout => false
        end
    end
    
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
        
        #begin
        #    Cjob.transaction do
        #       rs = Cjob.find(888)
        #       rs.jobname = "งานทดสอบ222"
        #       rs.save!
        #       rs2 = Cposition.find(99999)
        #       rs2.posname = 'ตำแหน่งทดสอบ222'
        #       rs2.save!
        #    end
        #    render :text => "{success: true}"
        #rescue
        #    return_data = {}
        #    return_data[:success] = false
        #    return_data[:msg] = "กรุณาลองตรวจสอบข้อมูลและลองใหม่อีกครั้ง"
        #    render :text => return_data.to_json, :layout => false
        #end
        
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
