package com.example.database_project_local_item_app;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageButton;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.fragment.app.Fragment;
import com.google.android.material.navigation.NavigationView;

public class HomeFragment extends Fragment {

    private DrawerLayout drawerLayout;

       public HomeFragment() {
           super(R.layout.fragment_home);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
           super.onViewCreated(view, savedInstanceState);
           drawerLayout = view.findViewById(R.id.drawer_layout);
           ImageButton menuButton = view.findViewById(R.id.top_menu);

        if (menuButton != null && drawerLayout != null) {
            menuButton.setOnClickListener(v -> {
                drawerLayout.openDrawer(GravityCompat.START);
            });
        }
        btnButton(view);

    }

    private void btnButton(View view) {
        NavigationView navigationView = view.findViewById(R.id.nav_view);
        View headerView = navigationView.getHeaderView(0);

        View rice = headerView.findViewById(R.id.rice);
        if (rice != null) {
            rice.setOnClickListener(v -> {
                moveFragment(new ricePageFragment());
                drawerLayout.closeDrawer(GravityCompat.START);
            });
        }

        View fruits = headerView.findViewById(R.id.fruits);
        if(fruits != null){
            fruits.setOnClickListener( v ->{
                moveFragment(new fruitsPageFragment());
                drawerLayout.closeDrawer(GravityCompat.START);
            });
        }

        View vagetable = headerView.findViewById(R.id.vagetable);
        if(vagetable != null){
            vagetable.setOnClickListener(v->{
                moveFragment(new vagetablePageFragment());
                drawerLayout.closeDrawer(GravityCompat.START);
            });
        }

        View chucksan = headerView.findViewById(R.id.chucksan);
        if(chucksan != null){
            chucksan.setOnClickListener(v->{
                moveFragment(new chucksanPageFragment());
                drawerLayout.closeDrawer(GravityCompat.START);
            });
        }

        View susan = headerView.findViewById(R.id.susan);
        if(susan != null){
            susan.setOnClickListener(v->{
                moveFragment(new susanPageFragment());
                drawerLayout.closeDrawer(GravityCompat.START);
            });
        }

        View gagong = headerView.findViewById(R.id.gagong_page);
        if(gagong != null){
            gagong.setOnClickListener(v->{
                moveFragment(new gagongPageFragment());
                drawerLayout.closeDrawer(GravityCompat.START);
            });
        }

        View kimchi_chamgirm = headerView.findViewById(R.id.kimchchamgirm_page);
        if(kimchi_chamgirm != null){
            kimchi_chamgirm.setOnClickListener(v->{
                moveFragment(new KimchCharmgirmPageFragment());
                drawerLayout.closeDrawer(GravityCompat.START);
            });
        }

        View hangwa_tthug = headerView.findViewById(R.id.hangwatthug_page);
        if(hangwa_tthug != null){
            hangwa_tthug.setOnClickListener(v->{
                moveFragment(new hangwatthugPageFragment());
                drawerLayout.closeDrawer(GravityCompat.START);
            });
        }



    }

    private void moveFragment(Fragment fragment) {
        if (getActivity() != null) {
            getActivity().getSupportFragmentManager()
                    .beginTransaction()
                    .replace(R.id.fragment_container_view, fragment)
                    .addToBackStack(null)
                    .commit();
        }
    }
}

