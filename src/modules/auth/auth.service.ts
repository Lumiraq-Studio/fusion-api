import {Injectable, UnauthorizedException} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {SystemUsers} from "../../schemas/system_user.schema";
import {Repository} from "typeorm";
import {JwtService} from "@nestjs/jwt";
import * as bcrypt from 'bcrypt';
import {SalesRep} from "../../schemas/sales_rep.schema";


@Injectable()
export class AuthService {

    constructor(
        @InjectRepository(SystemUsers)
        private readonly userRepository: Repository<SystemUsers>,@InjectRepository(SalesRep)
        private readonly salesRepRepository: Repository<SalesRep>,
        private readonly jwtService: JwtService,
    ) {
    }

    async validateUser(username: string, password: string) {
        const user = await this.userRepository.findOne({
            where: { username },
            relations: ['user', 'salesReps'],
        });

        if (user && (await bcrypt.compare(password, user.password))) {
            return {
                id: user.id,
                username: user.username,
                role: user.role,
                permissions: user.permissions,
                salesRep: user.salesReps?.length ? {
                    id: user.salesReps[0].id,
                    name: user.salesReps[0].name,
                } : null,
            };
        }
        return null;
    }
    async login(username: string, password: string) {
        const user = await this.validateUser(username, password);
        if (!user) {
            throw new UnauthorizedException('Invalid credentials');
        }
        console.log(user)
        const payload = {username: user.username, sub: user.id, role: user.role};
        return {
            access_token: this.jwtService.sign(payload),
            userName: user.username,
            userId:  user.salesRep?.id,
            role: user.role,
            permissions: user.permissions,
        };
    }


}
