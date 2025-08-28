import {Body, Controller, Post} from '@nestjs/common';
import {SysUserService} from './sys-user.service';
import {CreateSystemUserDTO} from "./sys-user.entity";

@Controller()
export class SysUserController {
  constructor(private readonly sysUserService: SysUserService) {}

  @Post()
  async create(@Body() createSystemUserDto: CreateSystemUserDTO) {
    return this.sysUserService.create(createSystemUserDto);
  }
}
