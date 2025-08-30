import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";
import {processData} from "../../utils/utils";
import {CreateVehicleDTO} from "./vehicle.entity";

@Injectable()
export class VehicleService {

    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }

    async create(createUserDTO: CreateVehicleDTO) {
        const result = await this.dataSourceRepository.query('CALL vehicle_save(?,?,?)', [
            createUserDTO.registration_no,
            createUserDTO.type,
            createUserDTO.capacity
        ])
        return processData(result, 0)
    }
}
