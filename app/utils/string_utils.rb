module StringUtils
	def trim value
		Maybe(value).strip!.fetch(value) unless value.nil?
	end

	def trim_and_downcase value
		result = trim value
    result.downcase unless result.nil?
	end

	def count_lines(str = "", force_break_after = 120)
		str ||= ""
		str
			.split("\n")
			.map{|str| str.split("")
				.each_slice(force_break_after)
				.map{|slice| slice.join}}
			.map{|i| i.empty? ? [nil] : i}.flatten.count
	end
end
