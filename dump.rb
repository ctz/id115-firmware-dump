#!/usr/bin/env ruby

require 'net/telnet'

debug = Net::Telnet::new("Host" => "localhost", 
                         "Port" => 4444)

dumpfile = File.open("dump.bin", "w")

((0x00000000/4)...(0x00040000)/4).each do |i|
  address = i * 4
  debug.cmd("reset halt")
  debug.cmd("reg pc 0x6dc")
  debug.cmd("reg r3 0x#{address.to_s 16}")
  debug.cmd("step")
  response = debug.cmd("reg r3")
  value = response.match(/: 0x([0-9a-fA-F]{8})/)[1].to_i 16
  dumpfile.write([value].pack("V"))
  puts "0x%08x:  0x%08x" % [address, value]
end

dumpfile.close
debug.close
