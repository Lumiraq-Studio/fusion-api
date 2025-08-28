import {Body, Controller, Post} from '@nestjs/common';
import {VehicleService} from './vehicle.service';
import {CreateVehicleDTO} from "./vehicle.entity";

@Controller()
export class VehicleController {
  constructor(private readonly vehicleService: VehicleService) {}


  @Post()
  async createUser(@Body() createUserDTO: CreateVehicleDTO) {
    return await this.vehicleService.create(createUserDTO);
  }
}
