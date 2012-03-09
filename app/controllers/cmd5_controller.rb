class Cmd5Controller < ApplicationController
    skip_before_filter :verify_authenticity_token
    
    #---------------------------------------------------------------------------

    #กรณีคำสั่งที่ 5 นี้ list_position จะหมายถึงค้นหาเพื่อต้องการผลลัพธ์ที่เป็นตำแหน่งข้าราชการปัจจุบัน
    def list_position
        start = params[:start].to_s
        limit = params[:limit].to_s
        condition_id = params[:condition_id].to_s
        query = params[:query].to_s
        
        sql = "SELECT pisj18.posid, cposition.shortpre, cposition.posname, cgrouplevel.clname, cprefix.prefix || pispersonel.fname || '  ' || pispersonel.lname AS fullname
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
                sql += " AND NOT(pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null))"
            when '2' #กรณีค้นหาด้วย ตำแหน่งสายงาน
                if query != ""
                    sql += " AND cposition.posname || cgrouplevel.clname LIKE '%#{query}%'"
                end
                sql += " AND NOT(pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null))"
            end
        end
        
        rs = Cjob.find_by_sql(sql)
        totalCount = rs.count()
        sql += " OFFSET #{start} LIMIT #{limit}"
        rs = Cjob.find_by_sql(sql)
        
        return_data = {}
        return_data[:totalCount] = totalCount
        return_data[:Records]   = rs.collect{|u|{
            :posid => u.posid,
            :posname => "#{u.shortpre}#{u.posname} #{u.clname}",
            :fullname => u.fullname
          }
        }
        render :text => return_data.to_json,:layout => false
    end
    
    def get_place
        id = params[:id]
        sql = "SELECT csubdept.shortpre || csubdept.subdeptname|| ' ' || camphur.shortpre ||
            camphur.amname || ' ' || cprovince.shortpre || cprovince.provname AS fullsubdeptname
            FROM csubdept
            JOIN camphur ON csubdept.amcode=camphur.amcode AND csubdept.provcode=camphur.provcode
            JOIN cprovince ON csubdept.provcode=cprovince.provcode
            WHERE csubdept.sdcode=#{id}"
        
        rs = Cjob.find_by_sql(sql)
        
        return_data = {}
        return_data[:Records]   = rs.collect{|u|{
            :fullsubdeptname => u.fullsubdeptname
        }}
        render :text => return_data.to_json,:layout => false
        
    end
    
    def list_place_dialog
        start = params[:start].to_s
        limit = params[:limit].to_s
        provcode = params[:provcode].to_s
        query = params[:query].to_s
        
        sql = "SELECT csubdept.sdcode, csubdept.shortpre || csubdept.subdeptname|| ' ' || camphur.shortpre ||
            camphur.amname || ' ' || cprovince.shortpre || cprovince.provname AS fullsubdeptname
            FROM csubdept
            JOIN camphur ON csubdept.amcode=camphur.amcode AND csubdept.provcode=camphur.provcode
            JOIN cprovince ON csubdept.provcode=cprovince.provcode
            WHERE 1=1"
        
        if provcode != ""
            sql += " AND cprovince.provcode=#{provcode}"
        end
        
        if query != ""
            sql += " AND csubdept.shortpre || csubdept.subdeptname|| ' ' || camphur.shortpre ||
            camphur.amname || ' ' || cprovince.shortpre || cprovince.provname LIKE '%#{query}%'"
        end
        
        rs = Cjob.find_by_sql(sql)
        totalCount = rs.count()
        sql += " ORDER BY fullsubdeptname OFFSET #{start} LIMIT #{limit}"
        rs = Cjob.find_by_sql(sql)
        
        return_data = {}
        return_data[:totalCount] = totalCount
        return_data[:Records]   = rs.collect{|u|{
            :sdcode => u.sdcode,
            :fullsubdeptname => u.fullsubdeptname
        }}
        render :text => return_data.to_json,:layout => false
    end
    
    def get_position
        posid = params[:posid]
        if posid == ""
            posid = 0
        end
        sql = "SELECT pisj18.poscode, pisj18.excode, pisj18.c AS ccode, pisj18.epcode, pisj18.ptcode, pisj18.mincode, 
            pisj18.deptcode, pisj18.dcode, pisj18.sdcode, pisj18.seccode, pisj18.jobcode, pisj18.salary,
            csubdept.shortpre || csubdept.subdeptname|| ' ' || camphur.shortpre || camphur.amname || ' ' || cprovince.shortpre || cprovince.provname AS fullsubdeptname,
            cprefix.prefix || pispersonel.fname || '  ' || pispersonel.lname as fullname
            FROM pisj18 
            JOIN csubdept ON pisj18.sdcode=csubdept.sdcode
            JOIN camphur ON csubdept.amcode=camphur.amcode AND csubdept.provcode=camphur.provcode
            JOIN cprovince ON csubdept.provcode=cprovince.provcode
            JOIN pispersonel ON pisj18.posid=pispersonel.posid
            JOIN cprefix ON pispersonel.pcode=cprefix.pcode
            WHERE pisj18.posid=#{posid} AND pispersonel.pstatus='1'"
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
            :fullname => u.fullname
        }}
        render :text => return_data.to_json,:layout => false
        
    end
    
    def save
        updcode = params[:updcode] #การเคลื่อนไหว
        refcmnd = params[:refcmnd] #คำสั่ง
        forcedate = params[:forcedate] #วันที่มีผลบังคับใช้

        posid = params[:posid] #เลขที่ตำแหน่ง

        poscode = params[:poscode] #ตำแหน่งสายงาน
        c = params[:c] #ระดับ
        salary = params[:salary] #เงินเดือน
        excode = params[:excode] #ตำแหน่งบริหาร
        epcode = params[:epcode] #ความเชี่ยวชาญ
        ptcode = params[:ptcode] #ว./วช./ชช.
        mincode = params[:mincode] #กระทรวง
        deptcode = params[:deptcode] #กรม
        dcode = params[:dcode] #กอง
        sdcode = params[:sdcode] #รหัสหน่วยงาน
        seccode = params[:seccode] #ฝ่าย /กลุ่มงาน
        jobcode = params[:jobcode] #งาน

        note = params[:note] #หมายเหตุ
        chk = params[:chk] #ตัดโอนตำแหน่งและอัตราเงินเดือน จะคืนค่า true กับ false
        
        upddate = params[:upddate] #วันที่บันทึก เดี๋ยวให้ทาง postgres บันทึกเวลาเอง
        upduser = params[:upduser] #user ที่บันทึก
        
        
        #หา id ซึ่งเป็น id ของคน จากค่าของ posid
        sql = "select id as pispersonel_id from pisj18 where posid=#{posid}"
        rs = Pispersonel.find_by_sql(sql)
        id = rs[0].pispersonel_id
        
        #หาการเรียงลำดับของคอลัมน์ historder
        sql = "select historder from pisposhis where id='#{id}' order by historder desc"
        rs = Pisposhis.find_by_sql(sql)
        historder = 1
        if rs.count() > 0
            historder = rs[0].historder.to_i + 1
        end
        
        begin
            Pisposhis.transaction do                
                
                #กำหนดให้เป็นตำแหน่งว่าง
                sql = "update pisj18 set id='', upddate=now(), upduser='#{upduser}'"
                #หากติ๊กเช็คบ๊อกซ์ ตัดโอนตำแหน่งและอัตราเงินเดือน
                if chk == "true"
                    sql += ", flagupdate='0'"
                end
                sql += " where posid=#{posid}"
                rs = Pisj18.find_by_sql(sql)
                
                #กำหนดสถานะบุคคลให้เป็นอดีตราชการ และเอาวันที่มีผลบังคับใช้ มาใส่เป็นวันที่ออกจากราชการด้วย
                sql = "update pispersonel set pstatus='0', exitdate='#{forcedate}', upddate=now(), upduser='#{upduser}' where id='#{id}'"
                rs = Pispersonel.find_by_sql(sql)
        
                #เพิ่มเรคอร์ดประวัติ
                rs3 = Pisposhis.new
                rs3.id = id
                rs3.historder = historder
                rs3.forcedate = forcedate
                rs3.poscode = poscode
                rs3.excode = excode
                rs3.epcode = epcode
                rs3.mcode = mincode
                rs3.dcode = dcode
                rs3.deptcode = deptcode
                rs3.sdcode = sdcode
                rs3.seccode = seccode
                rs3.jobcode = jobcode
                rs3.updcode = updcode
                rs3.posid = posid
                rs3.c = c
                rs3.salary = salary
                rs3.refcmnd = refcmnd
                rs3.ptcode = ptcode
                rs3.note = note
                #rs3.update = ''
                rs3.upduser = upduser
                rs3.save!
            end
            
            return_data = {}
            return_data[:success] = true
            render :text => return_data.to_json, :layout => false
        rescue
            return_data = {}
            return_data[:success] = false
            render :text => return_data.to_json, :layout => false
        end
    end
    
end










