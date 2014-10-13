guard 'shell', all_on_start: true do
  watch(%r{(lib|test)/.*?.exs?}) { `mix test` }
end
