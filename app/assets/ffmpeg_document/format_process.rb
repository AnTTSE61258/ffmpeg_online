class FormatGenerator
  init
  def self.init
    Format.delete_all
    text = File.open(Dir.pwd + '/app/assets/ffmpeg_document/f.txt').read
    text.gsub!(/\r\n?/, "\n")
    result = []
    text.each_line do |line|
      a = line.gsub(/\s+/m, ' ').strip.split(' ')
      description = ''
      for num in 2..a.size do
        description << a[num].to_s + ' '
      end
      description.strip!
      item = [a[1], description]
      result << item
      f = Format.new(:name => item[0],:description => item[1])
      f.save
    end
    p result
  end
end

