import {Body, Controller, Get, Param, Patch, Post, Query} from '@nestjs/common';
import {UserService} from './user.service';
import {CreateUserDTO, UpdateUserDTO} from "./user.entity";

@Controller()
export class UserController {
    constructor(private readonly userService: UserService) {
    }

    @Get('find')
    async findUsers(
        @Query('full_name') fullName: string,
        @Query('designation') designation: string,
        @Query('nic') nic: string,
        @Query('email') email: string,
        @Query('status') status: string,
        @Query('items_per_page') itemsPerPage: number,
        @Query('page_number') pageNumber: number
    ) {
        return await this.userService.find(
            fullName,
            designation,
            nic,
            email,
            status,
            itemsPerPage,
            pageNumber
        );
    }

    @Post()
    async createUser(@Body() createUserDTO: CreateUserDTO) {
        return await this.userService.create(createUserDTO);
    }

    @Get(':id')
    async getUser(@Param('id') id: number) {
        return await this.userService.get(+id);
    }

    @Patch(':id')
    async update(@Param('id') id: number, @Body() updateUserDTO: UpdateUserDTO) {
        return await this.userService.update(id, updateUserDTO);
    }
}

