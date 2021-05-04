import Config

if Mix.env() == :test do
  config :retro, Retro.Phoenix.HTML.SVG, dir: "test/retro/phoenix_html/svg_icons"
end
