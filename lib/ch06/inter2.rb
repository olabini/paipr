
def interactive_interpreter(prompt, 
                            transformer = nil, 
                            &block)
  transformer ||= (block || proc { |arg| arg })
  while true
    begin
      case prompt
      when String
        print prompt
      when Proc
        prompt.call
      end
      puts(transformer[gets])
    rescue Interrupt
      return
    rescue Exception => e
      puts ";; Error #{e.inspect} ignored, back to top level"
    end
  end
end

def prompt_generator(num = 0, ctl_string = "[%d] ")
  lambda do 
    print ctl_string%[num+=1]
  end
end

interactive_interpreter(prompt_generator)
