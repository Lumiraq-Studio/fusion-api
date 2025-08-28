import {BaseEntity, Column, Entity, PrimaryGeneratedColumn} from "typeorm";


@Entity('tbl_apk_details')
export class ApkDetails extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    version: string;

    @Column()
    platform: string;

    @Column()
    apkSize: string;

    @Column()
    status: string;

    @Column()
    releaseDate: string;

    @Column()
    apkLink: string;

}