require 'yaml'
require 'multi_json'

module ViewImport
  def from_hash(source)
    Class.new(View) { import_hash(source) }
  end

  def import_hash(source)
    source.each do |(k,v)|
      case v
      when Array
        pane(k) { v.each { |f| field(f['name'], f['alias']) } }
      when Hash
        field(v['name'], v['alias'])
      end
    end
  end

  def import_json(json)
    import_hash(MultiJson.decode(json))
  end

  def import_json_file(file)
    import_json(read_file(file))
  end

  def import_yaml(yaml)
    import_hash(YAML.safe_load(yaml))
  end

  def import_yaml_file(file)
    import_yaml(read_file(file))
  end

  def from_yaml(yaml)
    from_hash(YAML.safe_load(yaml))
  end

  def from_json(json)
    from_hash(MultiJson.decode(json))
  end

  def from_yaml_file(file)
    from_yaml(read_file(file))
  end

  def from_json_file(file)
    from_json(read_file(file))
  end

  def read_file(filename)
    root = File.expand_path('..', __dir__)
    File.read(File.join(root, filename))
  end
end
