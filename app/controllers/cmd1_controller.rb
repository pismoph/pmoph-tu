class Cmd1Controller < ApplicationController
    skip_before_filter :verify_authenticity_token

    #---------------------------------------------------------------------------
    
    def get_old_person
        pispersonel_id = params[:pispersonel_id]
        sql = "select pispersonel.id, pispersonel.pid, pispersonel.pcode, pispersonel.fname, pispersonel.lname, pispersonel.j18code, pispersonel.spexpos, pispersonel.mincode, 
        pispersonel.deptcode, pispersonel.dcode, pispersonel.sdcode, 
        csubdept.shortpre || csubdept.subdeptname|| ' ' || camphur.shortpre || camphur.amname || ' ' || cprovince.shortpre || cprovince.provname as fullsubdeptname,
        pispersonel.seccode, pispersonel.jobcode, pispersonel.sex, pispersonel.bloodgroup, pispersonel.birthdate, pispersonel.appointdate, pispersonel.deptdate, 
        pispersonel.cdate, pispersonel.exitdate, pispersonel.qcode, pispersonel.macode, pispersonel.codetrade, pispersonel.kbk, pispersonel.specialty, 
        pispersonel.note, pispersonel.note2, pispersonel.getindate, pispersonel.reentrydate, pispersonel.quitdate, pispersonel.attenddate
        from pispersonel
        join csubdept on pispersonel.sdcode=csubdept.sdcode
        join camphur on csubdept.amcode=camphur.amcode and csubdept.provcode=camphur.provcode
        join cprovince on csubdept.provcode=cprovince.provcode
        where pispersonel.id='#{pispersonel_id}'"
        
        rs = Pispersonel.find_by_sql(sql)
        
        return_data = {}
        return_data[:Records]   = rs.collect{|u|{
            :pid => u.pid,
            :pcode => u.pcode,
            :fname => u.fname,
            :lname => u.lname,
            :j18code => u.j18code,
            :spexpos => u.spexpos,
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
            :note2 => u.note2,
            :getindate => u.getindate,
            :reentrydate => u.reentrydate,
            :quitdate => u.quitdate,
            :attenddate => u.attenddate
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
        
        rs = Pispersonel.find_by_sql(sql)
        totalCount = rs.count()
        sql += " OFFSET #{start} LIMIT #{limit}"
        rs = Pispersonel.find_by_sql(sql)
        
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
        
        sql = "SELECT
            pisj18.posid,
            coalesce(cposition.shortpre,'') || coalesce(cposition.posname,'') || ' ' || coalesce(cgrouplevel.clname,'') as posname,
            coalesce(cprefix.prefix,'') || coalesce(pispersonel.fname,'') || '  ' || coalesce(pispersonel.lname,'') AS fullname
            FROM pisj18
            LEFT JOIN cposition ON cposition.poscode=pisj18.poscode
            LEFT JOIN cgrouplevel ON cgrouplevel.ccode=pisj18.c
            LEFT JOIN pispersonel ON pispersonel.id=pisj18.id
            LEFT JOIN cprefix ON cprefix.pcode=pispersonel.pcode
            WHERE 1=1"
        
        if condition_id != ""
            
            case condition_id
            #when '1' #กรณีค้นหาด้วย ชื่อ-นามสกุลของผู้ครองตำแหน่ง
            #    if query != ""
            #        sql += " AND cprefix.prefix || pispersonel.fname || pispersonel.lname LIKE '%#{query}%'"
            #    end
            #    sql += " AND NOT(pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null))"
            when '1' #กรณีค้นหาด้วย ตำแหน่งสายงาน
                if query != ""
                    sql += " AND coalesce(cposition.shortpre,'') || coalesce(cposition.posname,'') || ' ' || coalesce(cgrouplevel.clname,'') LIKE '%#{query}%'"
                end
                #sql += " AND NOT(pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null))"
            #when '3' #กรณีค้นหาด้วยตำแหน่งว่าง จะไม่สนใจคำค้นหา มันจะแสดงตำแหน่งว่างทั้งหมดที่มี
                #sql += " AND pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null)"
            end
            
            #ทุกเงื่อนไขค้นหา จะต้องเอามาเฉพาะตำแหน่งว่างเท่านั้น
            sql += " AND pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null) order by posname"
        end
        
        rs = Pisj18.find_by_sql(sql)
        totalCount = rs.count()
        sql += " OFFSET #{start} LIMIT #{limit}"
        rs = Pisj18.find_by_sql(sql)
        
        return_data = {}
        return_data[:totalCount] = totalCount
        return_data[:Records]   = rs.collect{|u|{
            :posid => u.posid,
            :posname => u.posname,
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
        
        rs = Pisj18.find_by_sql(sql)
        
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
        
        sql = "select id, pstatus from pispersonel where pid='#{pid}'"
        rs = Pispersonel.find_by_sql(sql)
        return_data = {}
        return_data[:Records]   = rs.collect{|u|{
            :id => u.id,
            :pstatus => u.pstatus
        }}
        render :text => return_data.to_json,:layout => false
    end
    
    def save_new
        id = params[:id].to_s
        pcode = params[:pcode].to_s
        fname = params[:fname].to_s
        lname = params[:lname].to_s
        sex = params[:sex].to_s
        birthdate = params[:birthdate][0,10].to_s
        appointdate = params[:appointdate][0,10].to_s
        deptdate = params[:deptdate][0,10].to_s
        cdate = params[:cdate][0,10].to_s
        deptcode = params[:deptcode].to_s
        dcode = params[:dcode].to_s
        sdcode = params[:sdcode].to_s
        seccode = params[:seccode].to_s
        jobcode = params[:jobcode].to_s
        poscode = params[:poscode].to_s
        excode = params[:excode].to_s
        epcode = params[:epcode].to_s
        macode = params[:macode].to_s
        qcode = params[:qcode].to_s
        posid = params[:posid].to_s
        c = params[:c].to_s
        salary = params[:salary].to_s
        j18code = params[:j18code].to_s
        spexpos = params[:spexpos].to_s
        note = params[:note].to_s
        upddate = params[:upddate][0,10].to_s
        upduser = params[:upduser].to_s
        codetrade = params[:codetrade].to_s
        kbk = params[:kbk].to_s
        pstatus = params[:pstatus].to_s
        ptcode = params[:ptcode].to_s
        pid = params[:pid].to_s
        mincode = params[:mincode].to_s
        note2 = params[:note2].to_s
        specialty = params[:specialty].to_s
        bloodgroup = params[:bloodgroup].to_s
        getindate = params[:getindate][0,10].to_s
        reentrydate = params[:reentrydate][0,10].to_s
        quitdate = params[:quitdate][0,10].to_s
        attenddate = params[:attenddate][0,10].to_s
        combo2 = params[:combo2].to_s
        combo3 = params[:combo3].to_s
        combo4 = params[:combo4].to_s
        combo5 = params[:combo5].to_s
        combo7 = params[:combo7].to_s
        combo8 = params[:combo8].to_s
        combo9 = params[:combo9].to_s
        combo10 = params[:combo10].to_s
        combo11 = params[:combo11].to_s
        combo13 = params[:combo13].to_s
        text6 = params[:text6].to_s
        updcode = params[:updcode].to_s
        refcmnd = params[:refcmnd].to_s
        forcedate = params[:forcedate][0,10].to_s
        hidOld = params[:hidOld].to_s #ถ้าเป็นอดีตข้าราชการ hidOld จะเท่ากับ 1
        
        #กรณีบันทึกคนใหม่ historder จะเป็น 1 แน่นอน
        historder = 1
        
        #หาเงินเดือนของ ถือจ่ายปีปัจจุบัน
        sql = "select nowsal from pisj18 where posid=#{posid}"
        rs = Pisj18.find_by_sql(sql)
        nowsal = rs[0].nowsal
        
        begin
            Pisposhis.transaction do
                
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
                rs1.spexpos = spexpos
                rs1.note = note
                rs1.upddate = upddate
                rs1.upduser = upduser
                rs1.codetrade = codetrade
                rs1.kbk = kbk
                rs1.pstatus = "1"
                rs1.ptcode = ptcode
                rs1.pid = pid
                rs1.mincode = mincode
                rs1.note2 = note2
                rs1.specialty = specialty
                rs1.bloodgroup = bloodgroup
                rs1.getindate = getindate
                rs1.reentrydate = reentrydate
                rs1.quitdate = quitdate
                rs1.attenddate = attenddate
                rs1.save!

                
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
                rs3.note = text6
                rs3.save!

                
                if c == "" 
                    c = "null"
                end
                
                if salary == "" 
                    salary = "null"
                end
                
                if combo2 == ""
                    combo2 = "null"
                end
                
                if combo3 == ""
                    combo3 = "null"
                end
                
                if combo4 == ""
                    combo4 = "null"
                end
                
                if combo5 == ""
                    combo5 = "null"
                end
                
                if combo7 == ""
                    combo7 = "null"
                end
                
                if combo8 == ""
                    combo8 = "null"
                end
                
                if combo9 == ""
                    combo9 = "null"
                end
                
                if combo10 == ""
                    combo10 = "null"
                end
                
                if combo11 == ""
                    combo11 = "null"
                end
                
                if combo13 == ""
                    combo13 = "null"
                end
                
                sql = "update pisj18 set id='#{id}', rem='#{text6}', emptydate=null, posmny=null"
                
                if salary.to_i > nowsal.to_i
                    #ถ้าเงินเดือนที่บรรจุมากกว่า  >> ถือจ่ายปัจจุบัน.  Update nowc, nowsal ,c ,salary. อาศัยเบิกปีก่อน is null
                    sql += ", c=#{c}, salary=#{salary}, nowc=#{c}, nowsal=#{salary}, nowcasb=null, nowsalasb=null"
                end
                if salary.to_i < nowsal.to_i 
                    #ถ้าเงินเดือนที่บรรจุน้อยกว่า >> update nowcasb,nowsal abs ,c, salary
                    sql += ", c=#{c}, salary=#{salary}, nowcasb=#{c}, nowsalasb=#{salary}"
                end
                
                sql += ", poscode=#{combo2}, excode=#{combo3}, mincode=#{combo4}, deptcode=#{combo5},
                jobcode=#{combo7}, epcode=#{combo9}, dcode=#{combo10}, seccode=#{combo11}, ptcode=#{combo13}"
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
            rs = Pispersonel.find_by_sql(sql)
            dat = rs[0].dat
            
            #จากนั้นนำตัวเลขนี้ไปค้นในตารางว่ามีซ้ำกันหรือไม่
            sql = "SELECT id FROM pispersonel WHERE id='#{dat}'"
            rs = Pispersonel.find_by_sql(sql)
            num = rs.count() #ถ้า num มากกว่า 0 แสดงว่าตัวเลขสุ่มนั้นซ้ำกัน
        end
        return_data = {}
        return_data[:dat] = dat
        render :text => return_data.to_json,:layout => false
    end
    
    
    
    def save_edit
        #id = params[:id].to_s
        pcode = params[:pcode].to_s
        fname = params[:fname].to_s
        lname = params[:lname].to_s
        sex = params[:sex].to_s
        birthdate = params[:birthdate][0,10].to_s
        appointdate = params[:appointdate][0,10].to_s
        deptdate = params[:deptdate][0,10].to_s
        cdate = params[:cdate][0,10].to_s
        deptcode = params[:deptcode].to_s
        dcode = params[:dcode].to_s
        sdcode = params[:sdcode].to_s
        seccode = params[:seccode].to_s
        jobcode = params[:jobcode].to_s
        poscode = params[:poscode].to_s
        excode = params[:excode].to_s
        epcode = params[:epcode].to_s
        macode = params[:macode].to_s
        qcode = params[:qcode].to_s
        posid = params[:posid].to_s
        c = params[:c].to_s
        salary = params[:salary].to_s
        j18code = params[:j18code].to_s
        spexpos = params[:spexpos].to_s
        note = params[:note].to_s
        upddate = params[:upddate][0,10].to_s
        upduser = params[:upduser].to_s
        codetrade = params[:codetrade].to_s
        kbk = params[:kbk].to_s
        pstatus = params[:pstatus].to_s
        ptcode = params[:ptcode].to_s
        pid = params[:pid].to_s
        mincode = params[:mincode].to_s
        note2 = params[:note2].to_s
        specialty = params[:specialty].to_s
        bloodgroup = params[:bloodgroup].to_s
        getindate = params[:getindate][0,10].to_s
        reentrydate = params[:reentrydate][0,10].to_s
        quitdate = params[:quitdate][0,10].to_s
        attenddate = params[:attenddate][0,10].to_s
        combo2 = params[:combo2].to_s
        combo3 = params[:combo3].to_s
        combo4 = params[:combo4].to_s
        combo5 = params[:combo5].to_s
        combo7 = params[:combo7].to_s
        combo8 = params[:combo8].to_s
        combo9 = params[:combo9].to_s
        combo10 = params[:combo10].to_s
        combo11 = params[:combo11].to_s
        combo13 = params[:combo13].to_s
        text6 = params[:text6].to_s
        updcode = params[:updcode].to_s
        refcmnd = params[:refcmnd].to_s
        forcedate = params[:forcedate][0,10].to_s
        hidOld = params[:hidOld].to_s #ถ้าเป็นอดีตข้าราชการ hidOld จะเท่ากับ 1
        
        #กรณีที่ดึงอดีตข้าราชการขึ้นมา ก็ให้  query เอา id ขึ้นมา โดยไม่ต้อง insert ตาราง pispersonel ใหม่อีก
        sql = "select id as pispersonel_id from pispersonel where pid='#{pid}'"
        rs = Pispersonel.find_by_sql(sql)
        id = rs[0].pispersonel_id
        
        #หาการเรียงลำดับของคอลัมน์ historder
        sql = "select id, historder as num from pisposhis where id='#{id}' order by historder desc"
        rs = Pisposhis.find_by_sql(sql)
        historder = 1
        if rs.count() > 0
            historder = rs[0].num.to_i + 1
        end
        
        #หาเงินเดือนของ ถือจ่ายปีปัจจุบัน
        sql = "select nowsal from pisj18 where posid=#{posid}"
        rs = Pisj18.find_by_sql(sql)
        nowsal = rs[0].nowsal
        
        begin
            Pisposhis.transaction do
                
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
                rs3.note = text6
                rs3.save!
                


                #กรณีเป็นอดีตข้าราชการ บรรจุกลับ ต้องไปเปลี่ยนค่า pstatus ให้เป็น1 เพื่อบอกว่ามีสถานะเป็นข้าราชการแล้ว
                
                if birthdate == ""
                    birthdate = "null"
                else
                    birthdate = "'#{birthdate}'"
                end
                
                if appointdate == "" 
                    appointdate = "null"
                else
                    appointdate = "'#{appointdate}'"
                end
                
                if deptdate == ""  
                    deptdate = "null"
                else
                    deptdate = "'#{deptdate}'"
                end
                
                if cdate == "" 
                    cdate = "null"
                else
                    cdate = "'#{cdate}'"
                end
                
                if deptcode == "" 
                    deptcode = "null"
                end
                
                if dcode == "" 
                    dcode = "null"
                end
                
                if sdcode == "" 
                    sdcode = "null"
                end
                
                if seccode == "" 
                    seccode = "null"
                end
                
                if jobcode == "" 
                    jobcode = "null"
                end
                
                if poscode == "" 
                    poscode = "null"
                end
                
                if excode == "" 
                    excode = "null"
                end
                
                if epcode == "" 
                    epcode = "null"
                end
                
                if macode == "" 
                    macode = "null"
                end
                
                if qcode == "" 
                    qcode = "null"
                end
                
                if c == "" 
                    c = "null"
                end
                
                if salary == "" 
                    salary = "null"
                end
                
                if j18code == "" 
                    j18code = "null"
                end
                
                if spexpos == "" 
                    spexpos = "null"
                end
                
                if upddate == "" 
                    upddate = "null"
                else
                    upddate = "'#{upddate}'"
                end
                
                if codetrade == "" 
                    codetrade = "null"
                end
                
                if ptcode == "" 
                    ptcode = "null"
                end
                
                if mincode == ""
                    mincode = "null"
                end
                
                if getindate == "" 
                    getindate = "null"
                else
                    getindate = "'#{getindate}'"
                end
                
                if reentrydate == "" 
                    reentrydate = "null"
                else
                    reentrydate = "'#{reentrydate}'"
                end
                
                if quitdate == "" 
                    quitdate = "null"
                else
                    #quitdate = "'#{quitdate}'"
                    quitdate = "null" #กรณีบรรจุกลับต้องเคลียร์วันที่ออกจากราชการ quitdate
                end
                
                if attenddate == "" 
                    attenddate = "null"
                else
                    attenddate = "'#{attenddate}'"
                end

                sql = "update pispersonel set 
                    pstatus='1', 
                    sex=#{sex}, 
                    birthdate=#{birthdate}, 
                    appointdate=#{appointdate}, 
                    deptdate=#{deptdate}, 
                    cdate=#{cdate}, 
                    deptcode=#{deptcode}, 
                    sdcode=#{sdcode}, 
                    seccode=#{seccode}, 
                    jobcode=#{jobcode}, 
                    poscode=#{poscode}, 
                    excode=#{excode}, 
                    epcode=#{epcode}, 
                    macode=#{macode}, 
                    qcode=#{qcode},  
                    c=#{c}, 
                    salary=#{salary}, 
                    j18code=#{j18code}, 
                    spexpos=#{spexpos}, 
                    note='#{note}', 
                    upddate=#{upddate}, 
                    upduser='#{upduser}', 
                    codetrade=#{codetrade}, 
                    kbk='#{kbk}', 
                    ptcode=#{ptcode}, 
                    pid='#{pid}', 
                    mincode=#{mincode}, 
                    note2='#{note2}', 
                    specialty='#{specialty}', 
                    bloodgroup='#{bloodgroup}', 
                    getindate=#{getindate}, 
                    reentrydate=#{reentrydate}, 
                    quitdate=#{quitdate}, 
                    attenddate=#{attenddate} 
                    where id='#{id}'"
                rs = Pispersonel.find_by_sql(sql)
                
               
                
                if combo2 == ""
                    combo2 = "null"
                end
                
                if combo3 == ""
                    combo3 = "null"
                end
                
                if combo4 == ""
                    combo4 = "null"
                end
                
                if combo5 == ""
                    combo5 = "null"
                end
                
                if combo7 == ""
                    combo7 = "null"
                end
                
                if combo8 == ""
                    combo8 = "null"
                end
                
                if combo9 == ""
                    combo9 = "null"
                end
                
                if combo10 == ""
                    combo10 = "null"
                end
                
                if combo11 == ""
                    combo11 = "null"
                end
                
                if combo13 == ""
                    combo13 = "null"
                end
                
                sql = "update pisj18 set id='#{id}', rem='#{text6}', emptydate=null, posmny=null"
                
                if salary.to_i > nowsal.to_i
                    #ถ้าเงินเดือนที่บรรจุมากกว่า  >> ถือจ่ายปัจจุบัน.  Update nowc, nowsal ,c ,salary. อาศัยเบิกปีก่อน is null
                    sql += ", c=#{c}, salary=#{salary}, nowc=#{c}, nowsal=#{salary}, nowcasb=null, nowsalasb=null"
                end
                if salary.to_i < nowsal.to_i 
                    #ถ้าเงินเดือนที่บรรจุน้อยกว่า >> update nowcasb,nowsal abs ,c, salary
                    sql += ", c=#{c}, salary=#{salary}, nowcasb=#{c}, nowsalasb=#{salary}"
                end
                
                sql += ", poscode=#{combo2}, excode=#{combo3}, mincode=#{combo4}, deptcode=#{combo5},
                jobcode=#{combo7}, epcode=#{combo9}, dcode=#{combo10}, seccode=#{combo11}, ptcode=#{combo13}"
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

end










