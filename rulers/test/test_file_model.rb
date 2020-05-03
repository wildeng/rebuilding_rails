require_relative 'test_helper'

class TestFileModel < Rulers::Model::FileModel
  @@db_folder = 'test/tmp'
end

class RulersModelTest < Minitest::Test
  def test
    TestFileModel.new('1.json','test/tmp')
  end
  
  def attributes
    {
      'submitter' => 'test user',
      'quote' => 'simple quote',
      'attribution' => 'me'
    }
  end

  def updated_attrs
    {
      'submitter' => 'test user',
      'quote' => 'complicated quote',
      'attribution' => 'me'
    }
  end

  def test_file_creation
    f = TestFileModel.create(attributes)
    path = "#{f.db_folder}/#{f.id}.json"
    assert_equal(File.exist?(path), true)
    clean_tmp_folder(f)
  end

  def test_file_update
    f = TestFileModel.create(attributes)
    path = "#{f.db_folder}/#{f.id}.json"
    assert_equal(File.exist?(path), true)
    f.update_attrs(updated_attrs)
    
    assert_equal(f['submitter'], updated_attrs['submitter'])
    assert_equal(f['quote'], update_attrs['quote'])
    assert_equal(f['attribution'], update_attrs['attribution'])

    clean_tmp_folder(f)
  end

  def clean_tmp_folder(file_model)
    files = Dir["#{file_model.db_folder}/*.json"]
    files.each do |file|
      File.delete(file) if File.exist?(file)
    end
  end
end
