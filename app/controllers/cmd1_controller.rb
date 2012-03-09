class Cmd1Controller < ApplicationController
    skip_before_filter :verify_authenticity_token

    #---------------------------------------------------------------------------
    
    def get_old_person
        pispersonel_id = params[:pispersonel_id]
        sql = "select pispersonel.id, pispersonel.pid, pispersonel.pcode, pispersonel.fname, pispersonel.lname, pispersonel.j18code, pispersonel.mincode, 
        pispersonel.deptcode, pispersonel.dcode, pispersonel.sdcode, 
        csubdept.shortpre || csubdept.subdeptname|| ' ' || camphur.shortpre || camphur.amname || ' ' || cprovince.shortpre || cprovince.provname as fullsubdeptname,
        pispersonel.seccode, pispersonel.jobcode, pispersonel.sex, pispersonel.bloodgroup, pispersonel.birthdate, pispersonel.appointdate, pispersonel.deptdate, 
        pispersonel.cdate, pispersonel.exitdate, pispersonel.qcode, pispersonel.macode, pispersonel.codetrade, pispersonel.kbk, pispersonel.specialty, 
        pispersonel.note, pispersonel.note2
        from pispersonel
        join csubdept on pispersonel.sdcode=csubdept.sdcode
        join camphur on csubdept.amcode=camphur.amcode and csubdept.provcode=camphur.provcode
        join cprovince on csubdept.provcode=cprovince.provcode
        where pispersonel.id='#{pispersonel_id}'"
        
        rs = Cjob.find_by_sql(sql)
        
        return_data = {}
        return_data[:Records]   = rs.collect{|u|{
            :pid => u.pid,
            :pcode => u.pcode,
            :fname => u.fname,
            :lname => u.lname,
            :j18code => u.j18code,
            :mincode => u.mincode,
            :deptcode => u.deptcode,
            :dcode => u.dcode,
            :sdcode => u.sdcode,
            :fullsubdeptname => u.fullsubdeptname,
            :seccode => u.seccode,
            :jobcode => u.jobcode,
            :sex => u.sex,
            :bloodgroup => u.bloodgroup,
            :birthdate => u.birthdate,
            :appointdate => u.appointdate,
            :deptdate => u.deptdate,
            :cdate => u.cdate,
            :exitdate => u.exitdate,
            :qcode => u.qcode,
            :macode => u.macode,
            :codetrade => u.codetrade,
            :kbk => u.kbk,
            :specialty => u.specialty,
            :note => u.note,
            :note2 => u.note2
        }}
        render :text => return_data.to_json,:layout => false
        
    end
    
    def list_old_person
        start = params[:start].to_s
        limit = params[:limit].to_s
        condition_id = params[:condition_id].to_s
        query = params[:query].to_s
        
        sql = "select pispersonel.posid, pispersonel.pid, cprefix.prefix, pispersonel.fname, pispersonel.lname, pispersonel.id as pispersonel_id, pisj18.id
            from pispersonel left join pisj18 on pisj18.id=pispersonel.id join cprefix on pispersonel.pcode=cprefix.pcode
            where pisj18.id is null"
        
        if condition_id != ""
            case condition_id
            when '1' #กรณีค้นหาด้วย เลขที่ตำแหน่ง
                if query != ""
                    sql += " and to_char(pispersonel.posid, '9999999999') like '%#{query}%'"
                end
            when '2' #กรณีค้นหาด้วย เลขประจำตัวประชาชน
                if query != ""
                    sql += " and (pispersonel.pid like '%#{query}%' or pispersonel.pid is null or pispersonel.pid='')"
                end
            when '3' #กรณีค้นหาด้วย ชื่อ-นามสกุล
                if query != ""
                    sql += " and pispersonel.fname || pispersonel.lname like '%#{query}%'"
                end
            end
        end
        
        rs = Cjob.find_by_sql(sql)
        totalCount = rs.count()
        sql += " OFFSET #{start} LIMIT #{limit}"
        rs = Cjob.find_by_sql(sql)
        
        return_data = {}
        return_data[:totalCount] = totalCount
        return_data[:Records]   = rs.collect{|u|{
            :pispersonel_id => u.pispersonel_id,
            :posid => u.posid,
            :pid => u.pid,
            :fullname => "#{u.prefix}#{u.fname}     #{u.lname}"
          }
        }
        render :text => return_data.to_json,:layout => false
    end
    
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
            when '3' #กรณีค้นหาด้วยตำแหน่งว่าง จะไม่สนใจคำค้นหา มันจะแสดงตำแหน่งว่างทั้งหมดที่มี
                sql += " AND pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null)"
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
    
    def age_calculate
        #datefield จะ post มาในรูปแบบ "1980-04-15T00:00:00"
        bDate = params[:bDate]
        birthDate = bDate[0, 10]
        yearDate = birthDate[0, 4]
        
        #คำนวณวันที่ครบเกษียณ หากเกิดตั้งแต่วันที่ 2 ตุลา ไปจนถึง 31 ธันวา จะต้องบวกปีครบเกษียณอีก 1 ปี
        m = birthDate[5, 2].to_i
        d = birthDate[8, 2].to_i
        plus_one = 0;
        if m == 10 || m == 11 || m==12
            if d >= 2
                plus_one = 1;
            end
        end
        
        sql = "SELECT
            EXTRACT(year from AGE(NOW(), '#{birthDate}')) AS age_y,
            EXTRACT(month from AGE(NOW(), '#{birthDate}')) AS age_m,
            EXTRACT(day from AGE(NOW(), '#{birthDate}')) AS age_d"
        rs = Cjob.find_by_sql(sql)
        age_y = rs[0].age_y
        age_m = rs[0].age_m
        age_d = rs[0].age_d
        
        #คำนวณระยะเวลาครบเกษียณ โดยเอาวันที่เกษียณตั้งลบด้วยวันที่ปัจจุบัน
        #หาวันที่ครบเกษีณก่อน
        sql = "SELECT #{yearDate.to_i}+60 || '-09-30' AS retire_date"
        rs = Cjob.find_by_sql(sql)
        retireDate = rs[0].retire_date
        
        #จากนั้น เอาวันที่เกษียณตั้ง ลบด้วยวันที่ปัจจุบัน
        sql = "SELECT
            EXTRACT(year from AGE('#{retireDate}', now())) AS retire_y,
            EXTRACT(month from AGE('#{retireDate}', now())) AS retire_m,
            EXTRACT(day from AGE('#{retireDate}', now())) AS retire_d"
        rs = Cjob.find_by_sql(sql)
        retire_y = rs[0].retire_y
        retire_m = rs[0].retire_m
        retire_d = rs[0].retire_d
        
        return_data = {}
        return_data[:Records]   = {
            :age_year => age_y,
            :age_text => "#{age_y} ปี #{age_m} เดือน #{age_d} วัน",
            :retire_date => "30/09/#{yearDate.to_i+60+543+plus_one}",
            :retire_text => "#{retire_y} ปี #{retire_m} เดือน #{retire_d} วัน"
        }
        render :text => return_data.to_json,:layout => false
    end
    
    def date_calculate
        #datefield จะ post มาในรูปแบบ "1980-04-15T00:00:00"
        dataDate = params[:dataDate][0,10]
        
        #การคำนวณระยะเวลาราชการต่างๆ จะต้องนับวันที่เข้ารับราชการด้วย ฉะนั้นต้องลบออก 1 วันก่อน
        sql = "SELECT date '#{dataDate}' - integer '1' AS newdate"
        rs = Cjob.find_by_sql(sql)
        newDate = rs[0].newdate
        
        #จากนั้นคำนวณ หาระยะเวลาราชการต่างๆ
        sql = "SELECT
        EXTRACT(year from AGE(timestamp '#{newDate}')) AS age_y,
        EXTRACT(month from AGE(timestamp '#{newDate}')) AS age_m,
        EXTRACT(day from AGE(timestamp '#{newDate}')) AS age_d"
        rs = Cjob.find_by_sql(sql)
        age_y = rs[0].age_y
        age_m = rs[0].age_m
        age_d = rs[0].age_d
        
        return_data = {}
        return_data[:Records]   = {
            :age_text => "#{age_y} ปี #{age_m} เดือน #{age_d} วัน"
        }
        render :text => return_data.to_json,:layout => false
    end
    
    def age_valid
        #datefield จะ post มาในรูปแบบ "1980-04-15T00:00:00"
        birthDate = params[:birthDate][0,10]
        validDate = params[:validDate][0,10]
        
        #คำนวณหาอายุ โดยนับจากวันที่มีผลบังคับใช้
        sql = "SELECT EXTRACT(year from AGE('#{validDate}', '#{birthDate}')) AS age_y"
        rs = Cjob.find_by_sql(sql)
        age_y = rs[0].age_y
        
        return_data = {}
        return_data[:Records]   = {
            :age_year => age_y
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
    
    def get_position_blank
        posid = params[:posid]
        if posid == ""
            posid = 0
        end
        sql = "SELECT pisj18.poscode, pisj18.excode, pisj18.c AS ccode, pisj18.epcode, pisj18.ptcode, pisj18.mincode, 
            pisj18.deptcode, pisj18.dcode, pisj18.sdcode, pisj18.seccode, pisj18.jobcode, pisj18.salary,
            csubdept.shortpre || csubdept.subdeptname|| ' ' || camphur.shortpre || camphur.amname || ' ' || cprovince.shortpre || cprovince.provname AS fullsubdeptname
            FROM pisj18 
            JOIN csubdept ON pisj18.sdcode=csubdept.sdcode
            JOIN camphur ON csubdept.amcode=camphur.amcode AND csubdept.provcode=camphur.provcode
            JOIN cprovince ON csubdept.provcode=cprovince.provcode
            WHERE pisj18.posid=#{posid}"
        #ต้องเป็นตำแหน่งว่างเท่านั้น
        sql += " AND pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null)"
        
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
            :fullsubdeptname => u.fullsubdeptname
        }}
        render :text => return_data.to_json,:layout => false
        
    end
    
    def pid_check_duplicate
        pid = params[:pid]
        
        sql = "select id from pispersonel where pid='#{pid}'"
        rs = Cjob.find_by_sql(sql)
        return_data = {}
        return_data[:Records]   = rs.collect{|u|{
            :id => u.id
        }}
        render :text => return_data.to_json,:layout => false
    end
    
    def save_new
        id = params[:id]
        pcode = params[:pcode]
        fname = params[:fname]
        lname = params[:lname]
        sex = params[:sex]
        birthdate = params[:birthdate]
        appointdate = params[:appointdate]
        deptdate = params[:deptdate]
        cdate = params[:cdate]
        deptcode = params[:deptcode]
        dcode = params[:dcode]
        sdcode = params[:sdcode]
        seccode = params[:seccode]
        jobcode = params[:jobcode]
        poscode = params[:poscode]
        excode = params[:excode]
        epcode = params[:epcode]
        macode = params[:macode]
        qcode = params[:qcode]
        posid = params[:posid]
        c = params[:c]
        salary = params[:salary]
        j18code = params[:j18code]
        note = params[:note]
        upddate = params[:upddate]
        upduser = params[:upduser]
        codetrade = params[:codetrade]
        kbk = params[:kbk]
        pstatus = params[:pstatus]
        ptcode = params[:ptcode]
        pid = params[:pid]
        mincode = params[:mincode]
        note2 = params[:note2]
        specialty = params[:specialty]
        bloodgroup = params[:bloodgroup]

        updcode = params[:updcode]
        refcmnd = params[:refcmnd]
        forcedate = params[:forcedate]
        
        hidOld = params[:hidOld] #ถ้าเป็นอดีตข้าราชการ hidOld จะเท่ากับ 1
        
        #กรณีที่ดึงอดีตข้าราชการขึ้นมา ก็ให้  query เอา pid ขึ้นมา โดยไม่ต้อง insert ตาราง pispersonel ใหม่อีก
        if hidOld != ""
            sql = "select id as pispersonel_id from pispersonel where pid='#{pid}'"
            rs = Pispersonel.find_by_sql(sql)
            id = rs[0].pispersonel_id
        end
        
        #หาการเรียงลำดับของคอลัมน์ historder
        sql = "select id, historder from pisposhis where id='#{id}' order by historder desc"
        rs = Cjob.find_by_sql(sql)
        historder = 1
        if rs.count() > 0
            historder = rs[0].historder.to_i + 1
        end

        #rs2 = Pisj18.find(posid.to_i)
        #rs2.id = id
        #rs2.nowsalasb = salary
        #rs2.salary = salary
        #rs2.save!
                
        begin
            Pisposhis.transaction do                
                if hidOld == "" #จะ insert เข้าตาราง pispersonel กรณีที่เพิ่มคนใหม่เท่านั้น
                    rs1 = Pispersonel.new
                    rs1.id = id
                    rs1.pcode = pcode
                    rs1.fname = fname
                    rs1.lname = lname
                    rs1.sex = sex
                    rs1.birthdate = birthdate
                    rs1.appointdate = appointdate
                    rs1.deptdate = deptdate
                    rs1.cdate = cdate
                    rs1.deptcode = deptcode
                    rs1.sdcode = sdcode
                    rs1.seccode = seccode
                    rs1.jobcode = jobcode
                    rs1.poscode = poscode
                    rs1.excode = excode
                    rs1.epcode = epcode
                    rs1.macode = macode
                    rs1.qcode = qcode
                    rs1.posid = posid
                    rs1.c = c
                    rs1.salary = salary
                    rs1.j18code = j18code
                    rs1.note = note
                    rs1.upddate = upddate
                    rs1.upduser = upduser
                    rs1.codetrade = codetrade
                    rs1.kbk = kbk
                    rs1.pstatus = pstatus
                    rs1.ptcode = ptcode
                    rs1.pid = pid
                    rs1.mincode = mincode
                    rs1.note2 = note2
                    rs1.specialty = specialty
                    rs1.bloodgroup = bloodgroup
                    rs1.save!
                else
                    #กรณีเป็นอดีตข้าราชการ บรรจุกลับ ต้องไปเปลี่ยนค่า pstatus ให้เป็น1 เพื่อบอกว่ามีสถานะเป็นข้าราชการแล้ว
                    sql = "update pispersonel set pstatus='1', posid=#{posid} where id='#{id}'"
                    rs = Pisj18.find_by_sql(sql)
                end

        
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
                rs3.save!
                
                sql = "update pisj18 set id='#{id}'"
                if salary != ""
                    sql += ", nowsalasb=#{salary}, salary=#{salary}"
                end
                sql += " where posid=#{posid}"
                rs = Pisj18.find_by_sql(sql)
        
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
    
    def random_pispersonel_id
        dat = ""
        num = 1
        while num > 0
            #เริ่มต้นให้สุ่มตัวเลขขึ้นมาก่อน 1 ชุด 13 หลัก
            sql = "SELECT '' || trunc(random() * 9999999999999) AS dat"
            rs = Cjob.find_by_sql(sql)
            dat = rs[0].dat
            
            #จากนั้นนำตัวเลขนี้ไปค้นในตารางว่ามีซ้ำกันหรือไม่
            sql = "SELECT id FROM pispersonel WHERE id='#{dat}'"
            rs = Cjob.find_by_sql(sql)
            num = rs.count() #ถ้า num มากกว่า 0 แสดงว่าตัวเลขสุ่มนั้นซ้ำกัน
        end
        return_data = {}
        return_data[:dat] = dat
        render :text => return_data.to_json,:layout => false
    end
end










