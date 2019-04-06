module ApplicationHelper
	# Returns the full title on a per-page basis
	def full_title(page_title = '')
		base_title = "Saturn"
		if page_title.empty?
			base_title
		else
			page_title + " | " + base_title
		end
	end

	def markdown(text)
		renderer = Redcarpet::Render::SmartyHTML.new(filter_html: true,
																								 hard_wrap: true,
																								 prettify: true)
		markdown = Redcarpet::Markdown.new(renderer, markdown_options)
		markdown.render(sanitize(text)).html_safe
	end

	def markdown_options
		options = {
			no_intra_emphasis: true,
			fenced_code_blocks: true,
			disable_indented_code_blocks: true,
			autolink: true,
			lax_spacing: true,
			space_after_headers: true,
			strikethrough: true,
			highlight: true,
			underline: true
		}
	end
end
