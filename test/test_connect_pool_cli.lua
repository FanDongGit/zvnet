
package.cpath = package.cpath..";./luaclib/?.so;"
package.path = package.path .. ";./lualib/?.lua;"

local socket = require "socket"
local evloop = require "evloop"
local timer = require "timer"

evloop.start()

local function test_loop()
    local i = 0
    while true do
        -- local cmd = socket.readline(fd)
        -- socket.write(fd, cmd .. "\n")
        local clientfd, err = socket.connect("127.0.0.1", 8989, {backlog = 1, pool_size = 2})
        print(clientfd, err)
        if not err then
            socket.write(clientfd, "hello\t".. clientfd .. "\n")
            local buf, errmsg = socket.readline(clientfd, "\n")
            if errmsg then
                print("err:", errmsg)
                socket.close(clientfd)
            else
                print("recv", clientfd, buf)
                socket.setkeepalive(clientfd)
            end
        end
        i = i+1
        socket.sleep(i<5 and 10 or 100)
    end
end

timer.add_timer(0, test_loop)
timer.add_timer(0, test_loop)
timer.add_timer(0, test_loop)
timer.add_timer(0, test_loop)

evloop.run()
