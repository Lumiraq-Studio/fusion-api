import {Body, Controller, Get, Param, Post, Put, Query} from '@nestjs/common';
import { MaterialsService } from './materials.service';
import {CreateMaterialDTO, UpdateMaterialDTO} from "./material.entity";

@Controller()
export class MaterialsController {
  constructor(private readonly materialsService: MaterialsService) {}

  @Post()
  async create(@Body() createMaterialDTO: CreateMaterialDTO) {
    return this.materialsService.create(createMaterialDTO);
  }


  @Get()
  async find(
      @Query('name') name: string = '',
      @Query('itemsPerPage') itemsPerPage: number = 10,
      @Query('pageNumber') pageNumber: number = 1
  ) {
    return this.materialsService.find(name, itemsPerPage, pageNumber);
  }

  // Get by ID
  @Get(':id')
  async get(@Param('id') id: number) {
    return this.materialsService.get(id);
  }

  // Update by ID
  @Put(':id')
  async update(
      @Param('id') id: number,
      @Body() updateMaterialDTO: UpdateMaterialDTO
  ) {
    return this.materialsService.update(id, updateMaterialDTO);
  }
}
