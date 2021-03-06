require 'erb'

class String
  def lines
    split $/
  end
  
  def strip_whitespace_at_line_ends
    lines.map {|line| line.gsub(/\s+$/, '')} * $/
  end
  
  def on_one_line
    lines.join(' ')
  end
  
  def encode_quotes
    gsub(/\"/, '\\"')
  end
end

module GreaseMaker
  class Preprocessor
    def include(*filenames)
      filenames.map {|filename| Preprocessor.new(filename, get_binding).to_s}.join("\n")
    end
    
    def includeCSS(filename)
      loaded = Preprocessor.new(filename, get_binding).to_s
      return loaded.on_one_line.encode_quotes
    end
    
    def initialize(filename, aBinding = nil)
      @filename = File.expand_path(filename)
      @template = ERB.new(IO.read(@filename), nil, '%')
      
      @myBinding = aBinding
    end
    
    def get_binding
      if (@myBinding == nil)
        return binding
      else
        return @myBinding
      end
    end
    
    def to_s
      @template.result(get_binding).strip_whitespace_at_line_ends
    end
  end
end

if __FILE__ == $0
  print Protodoc::Preprocessor.new(ARGV.first)
end
