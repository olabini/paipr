$dbg_ids = []

def dbg(id, format, *args)
  if $dbg_ids.include?(id)
    $stderr.puts(format%args)
  end
end

def debug(*ids)
  $dbg_ids = ($dbg_ids + ids).uniq
end

def undebug(*ids)
  $dbg_ids -= ids
end

def dbg_indent(id, indent, format, *args)
  if $dbg_ids.include?(id)
    $stderr.print "  "*indent
    $stderr.puts(format%args)
  end
end
