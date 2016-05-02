guard 'livereload' do
  watch('app/controllers/testing_controller.rb')
  watch(%r{^app/prawn/.+\.rb})
end

guard :minitest, zeus: true do
  watch(%r{^test/factories/.+_factory\.rb$})  { 'test' }
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})          { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/test_helper\.rb$})           { 'test' }
end
