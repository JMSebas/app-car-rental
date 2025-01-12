class UserSerializer < Panko::Serializer
attributes :id, 
            :fullname,
            :email,
            :address,
            :phone


def fullname 
 "#{object.name} #{object.lastname}"
end

end