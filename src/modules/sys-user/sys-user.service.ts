import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {Repository} from "typeorm";
import {SystemUsers} from "../../schemas/system_user.schema";
import * as bcrypt from 'bcrypt';
import {CreateSystemUserDTO} from "./sys-user.entity";
import {Employee} from "../../schemas/user.schema";

@Injectable()
export class SysUserService {

    constructor(
        @InjectRepository(SystemUsers)
        private readonly systemUserRepository: Repository<SystemUsers>,
        @InjectRepository(Employee)
        private readonly userRepository: Repository<Employee>,
    ) {
    }

    async create(createSystemUserDto: CreateSystemUserDTO) {
        const {username, password, role, permissions, userId} = createSystemUserDto;
        const hashedPassword = await bcrypt.hash(password, 10);
        const user = await this.userRepository.findOne({where: {id: userId}});

        if (!user) {
            throw new Error('User not found');
        }

        const newUser = this.systemUserRepository.create({
            username,
            password: hashedPassword,
            role,
            permissions,
            user,
        });
        return this.systemUserRepository.save(newUser);
    }

}
