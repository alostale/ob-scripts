BEGIN {
  OFS = "\t"
}

/Commits not associated to any issue/ {
  exit
}

/<h2>/ {
  title = gensub(/.*<h2>(.*)<\/h2>/,"\\1", "g", $0)
  print "\n" title
}

/<a[^>]*>([0-9]*)<\/a>/ {
  split($0, fields, ">")

  id = cleanField(fields[4])
  desc = cleanField(fields[7])
  reporter = cleanField(fields[9])
  assigned = cleanField(fields[11])

  print id, desc, reporter, assigned
}

function cleanField(field) {
   sub(/<\/.*/, "", field)
   return field
}