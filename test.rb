require "FileUtils"

source = Dir.pwd + "/"
destination = "/Users/Malcolm.Wilson/Codebase/pixelrevision/as3/src" #CHANGE THIS TO AN ABSOLUTE PATH TO THE ROOT OF THE SVN REPO

if destination == "/tmp/":
  puts "NOT DOING ANYTHING. DEST DIRECTORY NOT SET"
  exit
end

p = File.join("**","*.*")
files = Dir.glob(p)
for file in files
  if file.match(/\.svn$/) then next end
  if file.match(/test\.rb/) then next end
  from = source+file
  to = destination+file
  pieces = to.split("/")
  pieces.pop()
  dir = pieces.join("/")
  
  puts dir
  FileUtils.mkdir_p(dir) #THIS WILL MAKE THE DIRS IF THEY DONT EXIST
  puts "FROM: " + from + " TO: " + to
  FileUtils.copy_file(from,to) #THIS WILL INITIATE THE COPY
end