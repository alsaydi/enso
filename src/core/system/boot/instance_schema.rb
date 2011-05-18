
require 'core/system/boot/schema_schema'

class InstanceSchema < SchemaGenerator

  primitive :str

  klass Instances do
    field :instances, :type => Instance, :optional => true, :many => true
  end

  klass Value do
  end

  klass Instance, :super => Value  do
    field :type, :type => :str
    field :contents, :type => Content, :optional => true, :many => true
  end

  klass Prim, :super => Value do
    field :kind, :type => :str
    field :value, :type => :str, :optional => true
  end

  klass Ref, :super => Value do
    field :name, :type => :str
  end

  klass Content do
  end

  klass Field, :super => Content do
    field :name, :type => :str
    field :values, :type => Value, :optional => true, :many => true
  end

  klass Code, :super => Content do
    field :code, :type => :str
  end
      

  patch_schema_pointers(schema)

end
