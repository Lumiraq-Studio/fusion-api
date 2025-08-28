import {Body, Controller, Get, Param, Patch, Post, Query} from '@nestjs/common';
import {ProductVariantService} from './product-variant.service';
import {UpdateBasePriceDTO, UpdateVariantDTO, VariantSaveDTO} from "./varinat.entity";

@Controller()
export class ProductVariantController {
  constructor(private readonly productVariantService: ProductVariantService) {}

  @Get('find')
  async findProducts(
      @Query('search_term') searchTerm: string,
      @Query('weight') weight: number,
      @Query('items_per_page') itemsPerPage: number,
      @Query('page_number') pageNumber: number
  ) {
    return await this.productVariantService.find(
        searchTerm,
        weight,
        +itemsPerPage,
        +pageNumber
    );
  }

  @Get(':id')
  async getOrder(@Param('id') id: number) {
    return await this.productVariantService.get(+id);
  }

  @Post()
  async create(@Body() createProductVariant:VariantSaveDTO) {
    return await this.productVariantService.create(createProductVariant);
  }

  @Patch('base-price/:id')
  async basePriceUpdate(@Param('id')id:number,@Body() updateBasePriceDTO:UpdateBasePriceDTO) {
    return await this.productVariantService.priceUpdate(id,updateBasePriceDTO);
  }


  @Patch(':id')
  async update(@Param('id')id:number,@Body() updateProductVariant:UpdateVariantDTO) {
    return await this.productVariantService.update(id,updateProductVariant);
  }




}
