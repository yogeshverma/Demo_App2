# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
# This module return a title on a per-page basis. When writing ordinary Ruby, you often write modules and INCLUDE them explicitly yourself,
# but in this case Rails handles the inclusion automatically for us. The result is that the title method is available in all our views

	def title					# Defining function
		base_title = "Art Quest Demo" 		# Variable assignment
		if @title.nil? 				# Boolean test for nil
			base_title			# Implicit return, different from Java
		else
			"#{base_title} | #{h(@title)}"	# String interplolation, just to avoid + concatenation
		end
	end
	
	def validation_messages_for(model, attribute)
	  "<font face='arial' size='2' color='red'>#{model.errors[attribute]}</font>" if model.errors[attribute]
	end
end
