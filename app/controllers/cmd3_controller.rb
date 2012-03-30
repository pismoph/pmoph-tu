class Cmd3Controller < ApplicationController
    skip_before_filter :verify_authenticity_token

    
    
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
        sql = "SELECT pispersonel.poscode, pispersonel.excode, pispersonel.c AS ccode, pispersonel.epcode, pispersonel.ptcode, pispersonel.mincode, 
            pispersonel.deptcode, pispersonel.dcode, pispersonel.sdcode, pispersonel.seccode, pispersonel.jobcode, pispersonel.salary,
            csubdept.shortpre || csubdept.subdeptname|| ' ' || camphur.shortpre || camphur.amname || ' ' || cprovince.shortpre || cprovince.provname AS fullsubdeptname,
            cprefix.prefix || pispersonel.fname || '  ' || pispersonel.lname as fullname, pispersonel.j18code, pispersonel.note
            FROM pispersonel 
            JOIN csubdept ON pispersonel.sdcode=csubdept.sdcode
            JOIN camphur ON csubdept.amcode=camphur.amcode AND csubdept.provcode=camphur.provcode
            JOIN cprovince ON csubdept.provcode=cprovince.provcode
            JOIN pisj18 ON pisj18.posid=pispersonel.posid
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
            :fullname => u.fullname,
            :j18code => u.j18code,
            :note => u.note
        }}
        render :text => return_data.to_json,:layout => false
        
    end
    
    def save
        updcode = params[:updcode] #การเคลื่อนไหว
        refcmnd = params[:refcmnd].to_s #คำสั่ง
        forcedate = params[:forcedate][0,10].to_s #วันที่มีผลบังคับใช้
        forcedatetext = params[:forcedatetext].to_s

        posid = params[:posid] #เลขที่ตำแหน่ง
        
        j18code = params[:j18code] #ปฏิบัติงานตรง จ.18
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
        subdcode = params[:subdcode] #กลุ่มภารกิจ
        seccode = params[:seccode] #ฝ่าย /กลุ่มงาน
        jobcode = params[:jobcode] #งาน
        fullname = params[:fullname] #ชื่อหน่วยงานแบบเต็ม

        note = params[:note] #หมายเหตุ
        
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
                
                #อัพเดตข้อมูลบุคคล แต่ยังไม่อัพเดต note 
                rs4 = Pispersonel.find(id)
                #rs4.note = pisnote
                rs4.j18code = j18code
                rs4.poscode = poscode
                rs4.excode = excode
                rs4.epcode = epcode
                rs4.mincode = mincode
                rs4.dcode = dcode
                rs4.deptcode = deptcode
                rs4.sdcode = sdcode
                rs4.subdcode = subdcode
                rs4.seccode = seccode
                rs4.jobcode = jobcode
                rs4.posid = posid
                rs4.c = c
                rs4.salary = salary
                rs4.ptcode = ptcode
                rs4.save!
                
                
                #หาการรวมหมายเหตุอัตโนมัติ
                sql = "select 
                    cdivision.prefix || cdivision.division as aaa, csubsdcode.subsdname as bbb,
                    csection.shortname || csection.secname as ccc, cjob.jobname as ddd
                    from pispersonel left join 
                    cdivision on pispersonel.dcode=cdivision.dcode left join 
                    csection on pispersonel.seccode=csection.seccode left join 
                    cjob on pispersonel.jobcode=cjob.jobcode left join
                    csubsdcode on pispersonel.subdcode=csubsdcode.subsdcode 
                    where pispersonel.posid=#{posid} "
                
                rs = Pispersonel.find_by_sql(sql)
                a1 = rs[0].aaa.to_s #กอง
                a2 = rs[0].bbb.to_s #กลุ่มภารกิจ
                a3 = rs[0].ccc.to_s #ฝ่าย/กลุ่มงาน
                a4 = rs[0].ddd.to_s #งาน
                if a4 != ""
                    a4 = "งาน"+a4
                end
                pisnote = "ไปปฏิบัติราชการ "+a1+" "+fullname.to_s+" "+a2+" "+a3+" "+a4+" ตั้งแต่ "+forcedatetext+" "+refcmnd
                #อัพเดตข้อมูลบุคคล เฉพาะ note อย่างเดียว
                rs4 = Pispersonel.find(id)
                rs4.note = pisnote
                rs4.save!
                
        
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
                rs3.subdcode = subdcode
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
                #rs3.upddate = ''
                #rs3.upduser = upduser
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

