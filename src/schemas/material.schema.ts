import {BaseEntity, Column, Entity, OneToMany, PrimaryGeneratedColumn} from 'typeorm';
import {MaterialStock} from "./material-stock.schema";


@Entity('tbl_material')
export class Material extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    code: string;

    @Column()
    name: string;

    @Column()
    description: string;

    @Column()
    unit: string;

    @OneToMany(() => MaterialStock, (stock) => stock.material)
    stocks: MaterialStock[];

}

