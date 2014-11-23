module Exceptions

using Docile

export FileDoesntExistsError

@docstrings

@doc "Is raised when a file doesn't exists" ->
type FileDoesntExistsError <: Exception
  filename::String
end

Base.showerror(io::IO, e::FileDoesntExistsError) =
  print(io, e.filename, " doesn't exists")

end
