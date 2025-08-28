import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {DataSource, Repository} from "typeorm";
import {processData, processPaginationData} from "../../utils/utils";
import {CreateRouteDTO, UpdateRouteDTO} from "./route.entity";

@Injectable()
export class RouteService {


    constructor(
        @InjectRepository(DataSource)
        private dataSourceRepository: Repository<DataSource>
    ) {
    }


    async  create(createRouteDTO:CreateRouteDTO){
        const result = await this.dataSourceRepository.query('CALL route_save(?,?)', [
            createRouteDTO.name,
            createRouteDTO.area,
        ])
        return processData(result, 0)

    }

    async find(
        route_name:string,
        area_name:string,
        items_per_page:number,
        page_number:number

    ) {
        const result = await this.dataSourceRepository.query('CALL route_find(?,?,?,?)',[
            route_name,
            area_name,
            items_per_page,
            page_number
        ])
        return processPaginationData(result)
    }

    async  get(id:number){
        const result = await this.dataSourceRepository.query('CALL route_get(?)',[
            id
        ])
        let data= processData(result,1)
        data.shops=JSON.parse(data.shops)
        return data
    }

    async update(id:number,updateRouteDTO:UpdateRouteDTO){
        const result = await this.dataSourceRepository.query('CALL route_update(?,?,?)', [
            id,
            updateRouteDTO.name,
            updateRouteDTO.area,
        ])
        return processData(result, 0)
    }

}
