import {Body, Controller, Get, Param, Patch, Post, Query} from '@nestjs/common';
import {RouteService} from './route.service';
import {CreateRouteDTO, UpdateRouteDTO} from "./route.entity";

@Controller()
export class RouteController {
    constructor(private readonly routeService: RouteService) {
    }


    @Get('find')
    async findRoutes(
        @Query('route_name') routeName: string,
        @Query('area_name') areaName: string,
        @Query('items_per_page') itemsPerPage: number,
        @Query('page_number') pageNumber: number
    ) {
        return await this.routeService.find(
            routeName,
            areaName,
            itemsPerPage,
            pageNumber
        );
    }

    @Post()
    async createRoute(@Body() createRouteDTO: CreateRouteDTO) {
        return await this.routeService.create(createRouteDTO);
    }

    @Get(':id')
    async getRoute(@Param('id') id: number) {
        return await this.routeService.get(id);
    }

    @Patch(':id')
    async update(@Param('id') id: number, @Body() updateRouteDTO: UpdateRouteDTO) {
        return await this.routeService.update(+id, updateRouteDTO);
    }


}
