<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class RoleAndPermissionSeeder extends Seeder
{
    public function run(): void
    {
        app()[\Spatie\Permission\PermissionRegistrar::class]->forgetCachedPermissions();

        $permissions = [
            'view users',
            'create users',
            'edit users',
            'delete users',
            'manage roles',
            'view reports',
            'create reports',
            'edit reports',
            'delete reports',
            'view master data',
            'manage master data',
        ];

        foreach ($permissions as $permission) {
            Permission::create(['name' => $permission]);
        }

        // Create roles
        $roles = ['admin', 'user', 'operator'];
        foreach ($roles as $role) {
            Role::create(['name' => $role]);
        }

        // Assign permissions
        $adminRole = Role::findByName('admin');
        $adminRole->givePermissionTo(Permission::all());

        $operatorRole = Role::findByName('operator');
        $operatorRole->givePermissionTo([
            'view reports',
            'create reports',
            'edit reports',
            'view master data'
        ]);
    }
}
