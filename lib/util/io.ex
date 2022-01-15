defmodule Util.Io do
  def stream do 
    %Util.IoStream{
      device: :standard_io,
      line_or_bytes: :line,
      raw: false
    }
  end
end

