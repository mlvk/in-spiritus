module StringUtils
	def trim value
		Maybe(value).strip!.fetch(value) unless value.nil?
	end

	def trim_and_downcase value
		result = trim value
    result.downcase unless result.nil?
	end
end
