import {Module} from '@nestjs/common';
import {AuthService} from './auth.service';
import {AuthController} from './auth.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {SystemUsers} from "../../schemas/system_user.schema";
import {Employee} from "../../schemas/user.schema";
import {PassportModule} from "@nestjs/passport";
import {JwtModule} from "@nestjs/jwt";
import {JwtStrategy} from "./jwt.strategy";
import {JWT_SECRET} from "../../utils/key/constants";
import {SalesRep} from "../../schemas/sales_rep.schema";

@Module({
    imports: [
        PassportModule,
        JwtModule.register({
            secret: JWT_SECRET,
            signOptions: {expiresIn: '1h'},
        }), TypeOrmModule.forFeature([SystemUsers, Employee,SalesRep])],
    controllers: [AuthController],
    providers: [AuthService, JwtStrategy],
})
export class AuthModule {
}
