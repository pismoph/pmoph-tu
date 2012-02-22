class Cmd4Controller < ApplicationController
    skip_before_filter :verify_authenticity_token
    
    #กรณีคำสั่งที่ 4 นี้ list_position จะหมายถึงค้นหาเพื่อต้องการผลลัพธ์ที่เป็นตำแหน่งข้าราชการปัจจุบัน
    def list_position
        start = params[:start].to_s
        limit = params[:limit].to_s
        condition_id = params[:condition_id].to_s
        query = params[:query].to_s
        
        sql = "SELECT pisj18.posid, cposition.shortpre, cposition.posname, cgrouplevel.clname,
            cprefix.prefix || pispersonel.fname || '  ' || pispersonel.lname AS fullname,
            pispersonel.id
            FROM pisj18
            LEFT JOIN cposition ON cposition.poscode=pisj18.poscode
            LEFT JOIN cgrouplevel ON cgrouplevel.ccode=pisj18.c
            LEFT JOIN pispersonel ON pispersonel.id=pisj18.id
            LEFT JOIN cprefix ON cprefix.pcode=pispersonel.pcode
            WHERE 1=1"
        
        if condition_id != ""
            
            case condition_id
            when '1' #กรณีค้นหาด้วย ชื่อ-นามสกุลของผู้ครองตำแหน่ง
                if query != ""
                    sql += " AND cprefix.prefix || pispersonel.fname || pispersonel.lname LIKE '%#{query}%'"
                end
            when '2' #กรณีค้นหาด้วย ตำแหน่งสายงาน
                if query != ""
                    sql += " AND cposition.posname || cgrouplevel.clname LIKE '%#{query}%'"
                end
            end
        end
        sql += " AND NOT(pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null)) ORDER BY pisj18.posid"
        
        rs = Pisj18.find_by_sql(sql)
        totalCount = rs.count()
        sql += " OFFSET #{start} LIMIT #{limit}"
        rs = Pisj18.find_by_sql(sql)
        
        return_data = {}
        return_data[:totalCount] = totalCount
        return_data[:Records]   = rs.collect{|u|{
            :posid => u.posid,
            :posname => "#{u.shortpre}#{u.posname} #{u.clname}",
            :fullname => u.fullname,
            :id => u.id
          }
        }
        render :text => return_data.to_json,:layout => false
    end
    
    def get_position
        posid = params[:posid]
        id = params[:id]
        
        sql = "SELECT pispersonel.poscode, pispersonel.excode, pispersonel.c AS ccode, pispersonel.epcode, pispersonel.ptcode, pispersonel.mincode, 
            pispersonel.deptcode, pispersonel.dcode, pispersonel.sdcode, pispersonel.seccode, pispersonel.jobcode, pispersonel.salary,
            csubdept.shortpre || csubdept.subdeptname|| ' ' || camphur.shortpre || camphur.amname || ' ' || cprovince.shortpre || cprovince.provname AS fullsubdeptname,
            cprefix.prefix || pispersonel.fname || '  ' || pispersonel.lname as fullname, pispersonel.j18code, pispersonel.note
            FROM pisj18 
            JOIN csubdept ON pisj18.sdcode=csubdept.sdcode
            JOIN camphur ON csubdept.amcode=camphur.amcode AND csubdept.provcode=camphur.provcode
            JOIN cprovince ON csubdept.provcode=cprovince.provcode
            JOIN pispersonel ON pisj18.posid=pispersonel.posid
            JOIN cprefix ON pispersonel.pcode=cprefix.pcode
            WHERE pispersonel.id='#{id}' AND pispersonel.posid=#{posid}"
        #ต้องเป็นตำแหน่งที่มีคนบรรจุเท่านั้น
        sql += " AND NOT(pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null))"
        
        rs = Cjob.find_by_sql(sql)
        
        return_data = {}
        return_data[:Records]   = rs.collect{|u|{
            :poscode => u.poscode,
            :excode => u.excode,
            :ccode => u.ccode,
            :epcode => u.epcode,
            :ptcode => u.ptcode,
            :mincode => u.mincode,
            :deptcode => u.deptcode,
            :dcode => u.dcode,
            :sdcode => u.sdcode,
            :seccode => u.seccode,
            :jobcode => u.jobcode,
            :salary => u.salary,
            :fullsubdeptname => u.fullsubdeptname,
            :fullname => u.fullname,
            :j18code => u.j18code,
            :note => u.note,
            :id => id
        }}
        render :text => return_data.to_json,:layout => false
        
    end
end
