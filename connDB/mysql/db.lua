local mysql = require "resty.mysql"

local db, err = mysql:new()
if not db then
    ngx.say("failed to instantiate nysql: ", err)
    return
end

-- 1second
db:set_timeout(1000)

local ok, err, errno, sqlstate = db:connect{
    host = "192.168.199.133",
    port = 3306,
    database = "shop",
    user = "root",
    password = "123456",
    max_packet_size = 1024 * 1024
}

if not ok then
    ngx.say("fialed to connect: ", err, ": ", errno, ": ", sqlstate)
    return
end

ngx.say("connected to mysql.")

res, err, errno, sqlstate = db:query("create table cats "
                                        .. "(id serial primary key, " 
                                        .. "name varchar(20))")
if not res then
    ngx.say("bad result: ", err, ": ", errno, ": ", sqlstate, ".")
    return
end

ngx.say("table cats created.")

-- YinXin is the name of my roommate's cat
res, err, errno, sqlstate = db:query("insert into cats (name) values (\'YinXin\')")
if not res then
    ngx.say("bad result: ", err, ": ", errno, ": ", sqlstate, ".")
    return
end

ngx.say("data insert success.")
