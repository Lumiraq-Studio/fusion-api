import {BaseEntity, Column, Entity, OneToMany, PrimaryGeneratedColumn} from 'typeorm';
import {Shop} from './shop.schema';

@Entity('tbl_route')
export class Route extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({type: 'varchar', length: 255})
    name: string;

    @Column({type: 'varchar', length: 255})
    area: string;

    @OneToMany(() => Shop, (shop) => shop.route)
    shops: Shop[];
}
