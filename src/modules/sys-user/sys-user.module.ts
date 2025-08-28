import {Module} from '@nestjs/common';
import {SysUserService} from './sys-user.service';
import {SysUserController} from './sys-user.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {SystemUsers} from "../../schemas/system_user.schema";
import {Employee} from "../../schemas/user.schema";

@Module({
  imports: [TypeOrmModule.forFeature([Employee,SystemUsers])],
  controllers: [SysUserController],
  providers: [SysUserService],
})
export class SysUserModule {}
