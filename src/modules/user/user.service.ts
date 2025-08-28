import {Injectable} from '@nestjs/common';
import {CreateUserDTO, UpdateUserDTO} from "./user.entity";
import {processData, processPaginationData} from "../../utils/utils";
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";

@Injectable()
export class UserService {


    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }

    async create(createUserDTO: CreateUserDTO) {
        const result = await this.dataSourceRepository.query('CALL user_save(?,?,?,?,?,?)', [
            createUserDTO.fullName,
            createUserDTO.designation,
            createUserDTO.nic,
            createUserDTO.email,
            createUserDTO.mobile,
            createUserDTO.createdBy,


        ])
        return processData(result, 0)
    }

    async find(
        fullName: string,
        designation: string,
        nic: string,
        email: string,
        status: string,
        itemsPerPage: number,
        pageNumber: number
    ) {
        const result = await this.dataSourceRepository.query('CALL user_find(?,?,?,?,?,?,?)', [
            fullName,
            designation,
            nic,
            email,
            status,
            itemsPerPage,
            pageNumber
        ])
        return processPaginationData(result)
    }

    async get(id: number) {
        const result = await this.dataSourceRepository.query('CALL user_get(?)', [
            id
        ])
        return processData(result, 1)

    }

    async update(id: number, updateUserDTO: UpdateUserDTO) {
        const result = await this.dataSourceRepository.query('CALL user_update(?,?,?,?,?,?,?)', [
            id,
            updateUserDTO.fullName,
            updateUserDTO.designation,
            updateUserDTO.nic,
            updateUserDTO.email,
            updateUserDTO.mobile,
            updateUserDTO.createdBy,

        ])
        return processData(result, 1)

    }

}
