package com.schemaforge.user.mapper;

import com.schemaforge.user.dto.UserResponse;
import com.schemaforge.user.entity.User;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface UserMapper {

    UserResponse toResponse(User user);
}