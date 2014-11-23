module CSV

using Docile

include("exceptions.jl")

export csv

@docstrings

@doc "csv is compose by 3 elements" ->
type csv
  size::(Int64,Int64)
  data::Array{Any,2}
  schema::Dict{String,Any}

  csv(data, schema) = new(size(data), data, schema)
end

Base.show(io::IO, e::csv) = print(io, "csv($(e.size), data, schema)")

function buildStructure(line)

end

function Lines(filename)
  if isfile(filename) && isreadable(filename)
      function _()
        open(filename) do file
          for line in readlines(file)
            produce(line)
          end
        end
      end
      return Task(_)
  else
    throw(FileDoesntExistsError(filename))
  end
end

Base.parse(filename::String, quotes::Bool, separator=",",
      comments=true, comment_char="#") = begin
  data = []
  r = Lines(filename)

  for line in r
    (csvLine, lineStat) = buildStructure(line; quotes=quotes, separator=separator,
                            comments=comments, comments_char=comment_char)

    while lineStat != :complete
      (csvLine, lineStat) = consolidate(csvLine, consume(r))
    end

    if data == []
      data = csvLine
    else
      vcat(data,csvLine)
    end
  end

  data
end

end
